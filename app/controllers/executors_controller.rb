class ExecutorsController < ApplicationController
  def index
    render json: ExecutorEnvironment::AVAILABLE.map { |env|
      {
        language: env::LANGUAGE,
        version: env::VERSION,
      }
    }
  end

  def show
    permitted_params = params.permit(:language)
    env = ExecutorEnvironment
      .find_by_language(permitted_params[:language])

    render json: {
      language: env::LANGUAGE,
      version: env::VERSION,
    }
  end

  def execute
    permitted_params = params.permit(:language, :code)
    language = permitted_params[:language]
    code = permitted_params[:code]

    env = ExecutorEnvironment.find_by_language(language)

    executor = Executor.new(env)

    stdout, stderr, rc = executor.run!(code)

    render json: {
      stdout: stdout,
      stderr: stderr,
      rc: rc,
    }
  end
end
