require 'rails_helper'

include ActionController::RespondWith

RSpec.describe NewsController, type: :request do
  before(:each) do
    @current_user = FactoryBot.create(:user)
    @news = FactoryBot.create(:news)
    @second_news = FactoryBot.create(:second_news)
    @third_news = FactoryBot.create(:third_news)
    @auth_params = {}
  end

  let!(:updated_news) do
    {
        news: {
            title: 'new_title',
            status: !@news.status
        }
    }
  end
  let!(:new_record) do
    {
        news: {
            title: Faker::Lorem.sentence,
            preview: Faker::Lorem.sentence,
            text: Faker::Lorem.paragraph,
            user_id: @current_user.id
        }
    }
  end
  describe 'Whether access is ocurring properly' do
    it 'getting news list' do
      get news_index_path
      expect(response).to have_http_status(:success)
      expect(response.body.empty?).to eq(false)
    end
    it 'getting news' do
      get news_path(@news.id)
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['id']).to eq(@news.id)
    end
    it 'gives authentication code if user is exist' do
      login
      expect(response.has_header?('access-token')).to eq(true)
    end

    it 'gives you a status 200 on signing in ' do
      login
      expect(response.status).to eq(200)
    end

    it 'deny access to a restricted page with an incorrect token' do
      user = FactoryBot.create(:random_user)
      login user
      auth_params = get_auth_params_from_login_response_headers(response).tap do |h|
        h.each do |k, _v|
          if k == 'access-token'
            h[k] = '123'
          end
        end
      end
      patch news_path(@news.id), params: updated_news, headers: auth_params
      expect(response).not_to have_http_status(:success)
    end
  end

  it 'Can update own news' do
    login
    patch news_path(@news.id), params: updated_news, headers: @auth_params
    expect(response).to have_http_status(:success)
    updated_news = JSON.parse(response.body)
    expect(updated_news[:title]).not_to eq(@news.title)
    expect(updated_news[:status]).not_to eq(@news.status)
  end

  it 'Create' do
    login
    post news_index_path, params: new_record, headers: @auth_params
    expect(response).to have_http_status(:success)
  end

  it 'Can not update someone else news' do
    user = FactoryBot.create(:random_user)
    login(user)
    patch news_path(@news.id), params: updated_news, headers: @auth_params
    expect(response).to have_http_status(:forbidden)
  end

  it 'Can not delete someone else news' do
    user = FactoryBot.create(:random_user)
    login(user)
    delete news_path(@news.id), headers: @auth_params
    expect(response).to have_http_status(:forbidden)
  end

  it 'Can delete own news' do
    login
    delete news_path(@news.id), headers: @auth_params
    expect(response).to have_http_status(:success)
  end

  it 'Give news list by user' do
    get news_list_by_user_path, params: {user_id: @current_user.id}
    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body).first['id']).to eq(@news.id)
  end

  context 'Read' do
    it 'someone else news' do
      user = FactoryBot.create(:random_user)
      login user
      get news_path(@news.id), headers: @auth_params
      expect(response).to have_http_status(:success)
      expect(ListReadNews.by_user(user.id).by_news(@news.id).exists?).to eq(true)
    end

    it 'own news' do
      login
      get news_path(@news.id), headers: @auth_params
      expect(ListReadNews.by_user(@current_user.id).by_news(@news.id).exists?).to eq(false)
    end
  end

  context 'Favorites' do
    it 'success add' do
      user = FactoryBot.create(:random_user)
      login user
      put news_add_to_favorites_path, params: {news_id: @news.id}, headers: @auth_params
      expect(response).to have_http_status(:success)
    end

    it 'failure to add' do
      user = FactoryBot.create(:random_user)
      login user
      put news_add_to_favorites_path, headers: @auth_params
      expect(response).to have_http_status(:bad_request)
    end
  end

  it 'should getting unreaded news by user' do
    user = FactoryBot.create(:random_user)
    login user
    get news_path(@news.id), headers: @auth_params
    get news_path(@third_news.id), headers: @auth_params
    get news_list_unreaded_path, headers: @auth_params
    list_news = JSON.parse(response.body)
    expect(list_news.count).to eq(2)
    list_news.each do |news|
      expect([@news.id, @third_news.id]).to include(news['id'])
    end
  end

  def login(user = nil)
    user ||= @current_user
    post new_user_session_path, params: {email: user.email, password: 'password'}.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    @auth_params = get_auth_params_from_login_response_headers response
  end

  def get_auth_params_from_login_response_headers(response)
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    auth_params = {
        'access-token' => token,
        'client' => client,
        'uid' => uid,
        'expiry' => expiry,
        'token_type' => token_type
    }
    auth_params
  end
end
