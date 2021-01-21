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
end
