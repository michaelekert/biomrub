# hanami-2n-generator

A project skeleton generator for **Hanami 2.2+** applications with a modern frontend stack and built-in CRUD resource generator.

## Features

- Built atop **Thor** for easy project scaffolding.
- Uses **Hanami** for backend web application development.
- Uses **React + Vite + TypeScript** for the frontend.
- Uses **Tailwind CSS** + **shadcn/ui** for modern, utility-first styling and components.
- Uses **PostgreSQL** coupled with **ROM** for database management.
- Provides **Warden** for session-based authentication.
- Creates separate backend/frontend directories with a clean interface between them.
- Ships with **built-in resource generator**:
  ```bash
  thor generate books name:string

## Resource generator

The starter includes a Thor-based resource generator that automates creating the full CRUD stack for your entities.

By running:
```bash
thor generate books name:string
```

**You get a complete resource setup including:**

- Database migration for the books table with specified columns.

- ROM repository to interact with the database.

- Validation contracts to ensure data integrity.

- Hanami actions for CRUD operations (index, show, create, update, destroy).

- React pages and components to list, create, edit, and view records.

## Usage

- `hanami db create`
  Creates the database for your application.

- `hanami db migrate`
  Runs database migrations, setting up tables and schema.

- `hanami db seed`
  Seeds the database with example users (`user@email#{i}.com`) all with password `supersecret`.

- In one terminal, start the backend server:
  `bundle exec hanami server`

- In a separate terminal, start the frontend server:
  `npm --prefix frontend run dev`

## Adding New Resources

To add a new resource (CRUD) to your application:

- Generate the resource with Thor
   ```bash
   thor generate books name:string
   ```
- Run database migrations to apply the new schema:
  `hanami db migrate`


## Using linters (Rubocop & Biome)

### How run Biome linter:

```bash
cd frontend
```

Now you can use:

```bash
npx @biomejs/biome check --write
```

or

```bash
npx @biomejs/biome check --write --unsafe
```


### How run Rubocop

```bash
rubocop -a
```