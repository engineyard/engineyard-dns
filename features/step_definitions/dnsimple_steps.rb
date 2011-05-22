Given /^I expect to create DNSimple::Record with attributes:$/ do |table|
  record = table.rows_hash
  p [record.delete("domain"), record.delete("name") || "", 
      record.delete("record_type") || "A", record.delete("content"), record]
  # DNSimple::Record.create(record.delete("domain"), record.delete("name") || "", 
  #     record.delete("record_type") || "A", record.delete("content"), record)
end


