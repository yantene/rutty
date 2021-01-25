class ExecutorsController < ApplicationController
  def index
    render json: EXECUTOR_ENVIRONMENTS.map { |env|
      {
        language: env::LANGUAGE,
        version: env::VERSION,
      }
    }
  end

  def show
    permitted_params = params.permit(:language)
    env = find_executor_environment_by_language(permitted_params[:language])

    render json: {
      language: env::LANGUAGE,
      version: env::VERSION,
    }
  end

  def execute
    permitted_params = params.permit(:language, :code)
    language = permitted_params[:language]
    code = permitted_params[:code]

    env = find_executor_environment_by_language(language)

    executor = Executor.new(env)

    stdout, stderr, rc = executor.run!(code)

    render json: {
      stdout: stdout,
      stderr: stderr,
      rc: rc,
    }
  end

  EXECUTOR_ENVIRONMENTS = [
    ExecutorEnvironment::Bash,
    ExecutorEnvironment::Ruby,
  ]

  # language を処理できる Executor を取得する
  # @param [String] language 言語名
  # @return [Class] language を処理できる Executor の class
  # @return [nil] language を処理できる Executor が無いときには nil を返す
  def find_executor_environment_by_language(language)
    EXECUTOR_ENVIRONMENTS.find { |env|
      env::LANGUAGE == language
    }
  end
end
