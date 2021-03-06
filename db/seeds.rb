# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

admin = User.find_or_initialize_by(email: "#{ENV.fetch("ADMIN_USERNAME", "admin")}@example.com")

if admin.new_record?
  admin.password = admin.password_confirmation = ENV.fetch("ADMIN_PASSWORD", "admin123")
end

admin.save!
