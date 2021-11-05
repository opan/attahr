namespace :db do
  desc 'Seeds database (only for development)'
  task seeds: :environment do
    user_repo = UserRepository.new
    password = BCrypt::Password.create('123')

    puts "Create User with Profile"
    user = user_repo.create_with_profile(User.new(
      email: 'foo@mail.com',
      username: 'foo',
      password_hash: password,
      superadmin: true,
      profile: Profile.new(name: 'foo')
    ))

    puts "Create default Roles in Org"
    org_member_role_repo = OrgMemberRoleRepository.new
    ['admin', 'staff'].each do |name|
      org_member_role_repo.create(OrgMemberRole.new(name: name))
    end

    puts "Create default Org"
    org_repo = OrgRepository.new
    org = org_repo.create(Org.new(name: 'default-org', display_name: 'Default Org'))

    admin_role = org_member_role_repo.get('admin')

    puts "Create default Member in Org"
    org_member_repo = OrgMemberRepository.new
    org_member_repo.create(OrgMember.new(
      org_id: org.id,
      profile_id: user.profile.id,
      org_member_role_id: admin_role.id
    ))

    puts "Create two dummy User with Profile"
    2.times do |t|
      dummy = user_repo.create_with_profile(
        User.new(
          email: "dummy#{t}@mail.com",
          username: "dummy#{t}",
          password_hash: password,
          profile: Profile.new(name: "dummy#{t}")
        )
      )

      org_member_repo.create(OrgMember.new(
        org_id: org.id,
        profile_id: dummy.profile.id,
        org_member_role_id: org_member_role_repo.get.id
      ))
    end

    puts "Create dummy Product Category"
    product_category = ProductCategoryRepository.new.create(ProductCategory.new(name: "Misc"))
    ProductCategoryOrgRepository.new.create(ProductCategoryOrg.new(product_category_id: product_category.id, org_id: org.id))

    puts "Create dummy Products for dummy Product Category"
    3.times do |t|
      product = ProductRepository.new.create(Product.new(name: "Item #{t}", sku: "0"*5+t.to_s, product_category_id: product_category.id, price: 10000))
      ProductOrgRepository.new.create(ProductOrg.new(product_id: product.id, org_id: org.id))
    end
  end
end
