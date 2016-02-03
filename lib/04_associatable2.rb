require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      t_o = self.class.assoc_options[through_name]
      s_o = t_o.model_class.assoc_options[source_name]

      key_val = self.send(t_o.foreign_key)

      s_o.model_class.parse_all(DBConnection.execute(<<-SQL, key_val)).first
      SELECT
        #{s_o.table_name}.*
      FROM
        #{t_o.table_name}
      JOIN
        #{s_o.table_name} ON #{t_o.table_name}.#{s_o.foreign_key} = #{s_o.table_name}.#{s_o.primary_key}
      WHERE
        #{t_o.table_name}.#{t_o.primary_key} = ?
      SQL
    end
  end
end
