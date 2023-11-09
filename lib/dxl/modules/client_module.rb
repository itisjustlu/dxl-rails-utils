# frozen_string_literal: true

module DXL
  module Modules
    module ClientModule
      attr_accessor :response

      def call(method = :get) = send("do_#{method}_request")

      def status = @response.status

      def body = @response.body

      def invalid? =             status < 100 || status >= 600
      def informational? =       status >= 100 && status < 200
      def successful? =          status >= 200 && status < 300
      def redirection? =         status >= 300 && status < 400
      def client_error? =        status >= 400 && status < 500
      def server_error? =        status >= 500 && status < 600
      def ok? =                  status == 200
      def created? =             status == 201
      def accepted? =            status == 202
      def no_content? =          status == 204
      def moved_permanently? =   status == 301
      def bad_request? =         status == 400
      def unauthorized? =        status == 401
      def forbidden? =           status == 403
      def not_found? =           status == 404
      def method_not_allowed? =  status == 405
      def precondition_failed? = status == 412
      def unprocessable? =       status == 422
      def redirect? =            [301, 302, 303, 307, 308].include? status

      private

      def is_basic_auth? = false

      def headers = {}

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
