require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL).first.map { |col_name| col_name.to_sym}
    SELECT
      *
    FROM
      #{table_name}
    SQL
  end

  def self.finalize!
    columns.each do |col|
      define_method("#{col}") { attributes[col] }
      define_method("#{col}=") { |val| attributes[col] = val }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name = self.to_s.tableize
    @table_name = "humans" if @table_name == "humen"
    @table_name
  end

  def self.all
    parse_all(DBConnection.execute(<<-SQL))
      SELECT
        *
      FROM
        #{table_name}
    SQL
  end

  def self.parse_all(results)
    results.map { |result| new(result) }
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |key, val|
      raise "unknown attribute '#{key}'" unless self.class.columns.include?(key.to_sym)
      send("#{key}=", val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |key| send("#{key}") }
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
