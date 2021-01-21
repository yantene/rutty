require "rails_helper"

RSpec.describe "Executors", type: :request do
  describe "#index" do
    it "正常にレスポンスを返すこと" do
      get executors_path
      aggregate_failures do
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end
    end

    it "スキーマが一致すること" do
      get executors_path
      assert_response_schema_confirm
    end
  end

  describe "#show" do
    it "正常にレスポンスを返すこと" do
      get executor_path("ruby")
      aggregate_failures do
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end
    end

    it "スキーマが一致すること" do
      get executor_path("ruby")
      assert_response_schema_confirm
    end
  end

  describe "#execute" do
    it "正常にレスポンスを返すこと" do
      post execute_executor_path("ruby"), params: {
        code: <<~RUBY,
          puts "Hello, world!"
          warn "Good bye, world!"
        RUBY
      }
      aggregate_failures do
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end
    end

    it "スキーマが一致すること" do
      post execute_executor_path("ruby"), params: {
        code: <<~RUBY,
          puts "Hello, world!"
          warn "Good bye, world!"
        RUBY
      }
      assert_response_schema_confirm
    end
  end
end
