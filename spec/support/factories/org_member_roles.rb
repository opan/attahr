Factory.define(:org_member_role) do |f|
  f.name "staff"
  f.timestamps
end

Factory.define(org_member_role_admin: :org_member_role) do |f|
  f.name 'admin'
end
