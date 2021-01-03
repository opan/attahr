namespace :db do
  desc 'Seeds database (only for development)'
  task seeds: :environment do
    user_repo = UserRepository.new
    password = BCrypt::Password.create('123')
    user = user_repo.create_with_profile(User.new(
      email: 'foo@mail.com',
      username: 'foo',
      password_hash: password,
      profile: Profile.new(name: 'foo')
    ))

    org_member_role_repo = OrgMemberRoleRepository.new

    ['admin', 'staff'].each do |name|
      org_member_role_repo.create(OrgMemberRole.new(name: name))
    end

    org_repo = OrgRepository.new
    org = org_repo.create(Org.new(name: 'default-org', display_name: 'Default Org'))

    admin_role = org_member_role_repo.get('admin')

    org_member_repo = OrgMemberRepository.new
    org_member_repo.create(OrgMember.new(
      org_id: org.id,
      profile_id: user.profile.id,
      org_member_role_id: admin_role.id
    ))
  end
end
