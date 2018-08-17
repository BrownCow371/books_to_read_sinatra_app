require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride
use BookListItemsController
use UsersController
use BooksController
use CategoriesControllera
run ApplicationController
