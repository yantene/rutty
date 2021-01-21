class ExecutorsController < ApplicationController
  def index
    render json: EXECUTORS.map { |executor|
      {
        language: executor::LANGUAGE,
        version: executor::VERSION,
      }
    }
  end

  def show
    permitted_params = params.permit(:language)
    executor = find_executor_by_language(permitted_params[:language])

    render json: {
      language: executor::LANGUAGE,
      version: executor::VERSION,
    }
  end

  def execute
    permitted_params = params.permit(:language, :code)
    language = permitted_params[:language]
    code = permitted_params[:code]

    executor = find_executor_by_language(language).new

    stdout, stderr, rc = executor.execute!(code)

    render json: {
      stdout: stdout,
      stderr: stderr,
      rc: rc,
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
