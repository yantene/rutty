require "rails_helper"

RSpec.describe ExecutorsController do
  describe "#find_executor_environment_by_language" do
    it "ExecutorEnvironment が存在する language を引数に与えると、その ExecutorEnvironment が返ること" do
      env = controller.find_executor_environment_by_language(ExecutorEnvironment::Ruby::LANGUAGE)

      expect(env).to eq(ExecutorEnvironment::Ruby)
    end

    it "ExecutorEnvironment が存在しない language を引数に与えると、nil が返ること" do
      env = controller.find_executor_environment_by_language("fictitious_lang")

      expect(env).to be_nil
    end
  end
end
