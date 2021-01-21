require "rails_helper"

RSpec.describe ExecutorsController do
  describe "#find_executor_by_language" do
    it "Executor が存在する language を引数に与えると、その Executor が返ること" do
      executor = controller.find_executor_by_language(RubyExecutor::LANGUAGE)

      expect(executor).to eq(RubyExecutor)
    end

    it "Executor が存在しない language を引数に与えると、nil が返ること" do
      executor = controller.find_executor_by_language("fictitious_lang")

      expect(executor).to be_nil
    end
  end
end
