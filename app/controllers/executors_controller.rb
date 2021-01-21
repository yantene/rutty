class ExecutorsController < ApplicationController
  def index
    render json: [
      {
        language: "ruby",
        version: "3.0.0",
      },
    ]
  end

  def show
    render json: {
      language: "ruby",
      version: "3.0.0",
    }
  end

  def execute
    render json: {
      stdout: "piyopiyo",
      stderr: "hogehoge",
      rc: 0,
    }
  end

  EXECUTORS = [
    RubyExecutor,
  ]

  # language を処理できる Executor を取得する
  # @param [String] language 言語名
  # @return [Class] language を処理できる Executor の class
  # @return [nil] language を処理できる Executor が無いときには nil を返す
  def find_executor_by_language(language)
    EXECUTORS.find { |executor|
      executor::LANGUAGE == language
    }
  end
end
