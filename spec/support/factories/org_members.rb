Factory.define(:org_member) do |f|
  f.association(:org)
  f.association(:org_member_role)
  f.association(:profile)
  f.timestamps
end
