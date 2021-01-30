module ExecutorEnvironment
  # ExecutorEnvironment::* がメソッドの共通化のためのモジュール。
  # extend して利用する。
  module Base
    # 対応する言語の Docker イメージの id を Redis に格納する際の key
    # @return [String] key
    def redis_key
      %W[
        executor_environment
        #{self::LANGUAGE}
        #{self::VERSION}
        image_id
      ].join("/")
    end

    # 対応する言語の Docker イメージの id を Redis から取得する。
    # @return [String] Docker イメージの id
    def image_id
      Redis.current.get(redis_key).tap do |id|
        raise "Image not found: #{self}" if id.nil?
      end
    end

    # 対応する言語の Docker イメージの id を Redis に格納する。
    # @param [String] id Docker イメージの id
    def image_id=(id)
      Redis.current.set(redis_key, id)
    end

    # 対応する言語の Docker イメージをビルドし、
    # self.image_id にイメージの id を格納する。
    # @return [Docker::Image] ビルド後のイメージ
    def build_image
      Docker::Image.build_from_dir(
        self::DOCKERFILE_DIR,
        buildargs: self::DOCKERFILE_ARGS.to_json,
      ).tap do |image|
        self.image_id = image.id
      end
    end
  end
end
