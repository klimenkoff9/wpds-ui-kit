localdev-storybook-in-nextjs:
	npx start-storybook -p 6006 --preview-url=/storybook/iframe.html --quiet --ci --force-build-preview

build: 
	npm run turbo:build
	bash scripts/vercel-build.sh

building-storybook:
	npx build-storybook --output-dir ./app/public/storybook --preview-url /storybook/iframe.html --force-build-preview --quiet

all-dev:
	npx concurrently -n 'workspaces,playroom,storybook,website' 'npm run watch --workspaces' 'npm run playroom:start' 'make localdev-storybook-in-nextjs' 'npm run website:dev'

start-storybook:
	start-storybook -p 6006 --quiet --ci

experimental-version:
	npx lerna version --preid=experimental --sign-git-tag=experimental --no-changelog --yes --force-publish

experimental-publish:
	npx lerna publish from-package --dist-tag experimental --yes

main-publish: 
	npx lerna publish from-git --yes --no-git-reset --no-verify-access

main-version:
	npx lerna version --conventional-commits --yes --force-publish

# create experimental release
experimental-release:
	make experimental-version
	npm run turbo:build:force
	make experimental-publish

# create main release
main-release:
	make main-version
	npm run turbo:build:force
	make main-publish

# create command for plop templates
new-component:
	npx plop --plopfile ./scripts/plopfile.js
	npx lerna link --force-local
	npm run bootstrap