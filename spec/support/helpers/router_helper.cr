module RouterHelper
  def create_request_and_return_io(router, request)
    io = IO::Memory.new
    response = HTTP::Server::Response.new(io)
    context = HTTP::Server::Context.new(request, response)
    router.call(context)
    response.close
    io.rewind
    HTTP::Client::Response.from_io(io, decompress: false)
  end

  def make_router_call(router, request, token : (String | Nil) = nil)
    io = IO::Memory.new
    response = HTTP::Server::Response.new(io)
    context = HTTP::Server::Context.new(request, response)
    unless token.nil?
      context.session["csrf.token"] = token
      context.params["_csrf"] = token
    end
    router.call(context)
  end

  def create_context(request)
    io = IO::Memory.new
    response = HTTP::Server::Response.new(io)
    HTTP::Server::Context.new(request, response)
  end
end
