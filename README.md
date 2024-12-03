# Experimenting with `porffor` and Stellar Contracts

Stellar Contracts: https://developers.stellar.org

This repository contains a simple 'min' contract that has a single function accepting two values and returning the value which is smaller. The contract code is found in the `contract.ts` file.

> [!WARNING]
> Contract code in this repository is experimental, not audited, and not intended, or fit, for any use.

```ts
export const min = (a: number, b: number): number => {
    if (a < b) {
        return a;
    }
    return b;
};
```

> [!NOTE]
> The use of an arrow function instead of a regular function is necessary to get porffor to avoid adding `this`, `this#type`, `newtarget`, and `newtarget#type` parameters to the exported function.

## Dependencies

- [`porffor`] – Compiles the TypeScript to Wasm. (Version `0.50.12`)
- [`stellar-cli`] – Encodes the env-meta.json and spec.json to Soroban's Env Meta and Spec. (Version `22.0.1`)
- [`wasm-cs`] – Writes the encoded Env Meta and Spec to the Wasm file. (Version `1.0.0`)

[`porffor`]: https://github.com/CanadaHonk/porffor
[`stellar-cli`]: https://developers.stellar.org/docs/build/smart-contracts/getting-started/setup#install-the-stellar-cli
[`wasm-cs`]: https://crates.io/crates/wasm-cs

## Usage

### Build

```
make build
```

Results in the following Wasm:

```wasm
(module
  (type (;0;) (func))
  (type (;1;) (func (param i64 i32 i64 i32) (result i64 i32)))
  (func (;0;) (type 0))
  (func (;1;) (type 1) (param i64 i32 i64 i32) (result i64 i32)
    local.get 0
    local.get 2
    i64.lt_s
    i32.eqz
    i32.eqz
    if  ;; label = @1
      local.get 0
      i32.const 1
      return
    end
    local.get 2
    i32.const 1
    return)
  (memory (;0;) 1)
  (export "$" (memory 0))
  (export "m" (func 0))
  (export "min" (func 1)))
```

Each input and output parameter is represented by a `i64` `i32` pair, where the `i64` is the value, and the `i32` indicates the JavaScript type. In the example above, the `1` indicates the JavaScript type is a `number`.

### Deploy

```
make deploy
```

> [!CAUTION]
> Deploy will fail with the following error because Soroban does not support the `multi-value` Wasm feature, but all exported functions are multi-value with porffor.
> > Module(Parser(BinaryReaderError { inner: BinaryReaderErrorInner { message: "func type returns multiple values but the multi-value feature is not enabled", offset: 14, needed_hint: None } }))
