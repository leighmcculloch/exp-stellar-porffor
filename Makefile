build:
	porf wasm \
		--module \
		--valtype=i64 \
		contract.ts \
		contract.wasm
	cat env-meta.json \
		| stellar-xdr encode --type ScEnvMetaEntry --output stream \
		| wasm-cs contract.wasm write contractenvmetav0
	cat spec.json \
		| stellar-xdr encode --type ScSpecEntry --output stream \
		| wasm-cs contract.wasm write contractspecv0
	wasm2wat contract.wasm
	ls -lah contract.wasm

deploy:
	stellar contract deploy --wasm contract.wasm --alias porf
