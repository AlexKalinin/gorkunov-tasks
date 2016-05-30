# Our database helper
class DbHelper
  def initialize(host, port, login, password, database)
    @host = host
    @port = port
    @login = login
    @password = password
    @database = database

    $logger.debug "#{self}: Trying to connect database #{database}"
    @connection = PG.connect(host: host, port: port, dbname: database, user: login, password: password)
    $logger.debug "#{self}: Connection successfull. Server version: #{@connection.server_version}"
  end

  def exec_query(query)
    $logger.debug "#{self}: Executing query: #{query}"
    @connection.exec(query)
  end

  # see https://deveiate.org/code/pg/PG/Connection.html
  def exec_params(query, params_arr)
    $logger.debug "#{self}: Executing query: #{query} with params #{params_arr}"
    @connection.exec_params(query, params_arr)
  end

  def disconnect
    @connection.close if @connection
    @connection = nil
    @host = nil
    @port = nil
    @login = nil
    @password = nil
    @database = nil
    $logger.debug "#{self}: #disconnect: done"
  end

  def to_s
    "[DbHelper #{@host}:#{@port}@#{@database}]"
  end
end