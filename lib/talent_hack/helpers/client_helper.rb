# frozen_string_literal: true

module TalentHack
  module Helpers
    module ClientHelper
      attr_accessor :response

      def call(method = :get)
        send("do_#{method}_request")
      end

      def status
        @response.status
      end

      def body
        @response.body
      end

      def invalid?;             status < 100 || status >= 600;        end
      def informational?;       status >= 100 && status < 200;        end
      def successful?;          status >= 200 && status < 300;        end
      def redirection?;         status >= 300 && status < 400;        end
      def client_error?;        status >= 400 && status < 500;        end
      def server_error?;        status >= 500 && status < 600;        end
      def ok?;                  status == 200;                        end
      def created?;             status == 201;                        end
      def accepted?;            status == 202;                        end
      def no_content?;          status == 204;                        end
      def moved_permanently?;   status == 301;                        end
      def bad_request?;         status == 400;                        end
      def unauthorized?;        status == 401;                        end
      def forbidden?;           status == 403;                        end
      def not_found?;           status == 404;                        end
      def method_not_allowed?;  status == 405;                        end
      def precondition_failed?; status == 412;                        end
      def unprocessable?;       status == 422;                        end
      def redirect?;            [301, 302, 303, 307, 308].include? status; end

      private

      def is_basic_auth?
        false
      end

      def headers
        {}
      end

      def params
      end

      def body_params
      end

      def do_get_request
        @response = connection.get(url, params)
      end

      def do_post_request
        @response = connection.post(url, body_params)
      end

      def do_patch_request
        @response = connection.patch(url, body_params)
      end

      def do_put_request
        @response = connection.put(url, body_params)
      end

      def do_delete_request
        @response = connection.delete(url)
      end

      def connection
        @connection ||= Faraday.new do |conn|
          conn.request :json
          conn.response :json, content_type: /\bjson$/
          conn.adapter :net_http
          headers.each do |k,v|
            conn.headers[k] = v
          end
        end
        @connection.basic_auth(username, password) if is_basic_auth?
        @connection
      end

      def username
        raise "implement in inherited class"
      end

      def password
        raise "implement in inherited class"
      end
    end
  end
end
