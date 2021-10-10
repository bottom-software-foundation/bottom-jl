# bottom.jl
An implementation of the humorous [Bottom encoding format](https://github.com/bottom-software-foundation/spec) in the [Julia](https://github.com/JuliaLang/julia) programming language.

Script usage:
```sh
julia bottom.jl [--bottomify/--regress] input_file output_file
```
Only one of `--bottomify` or `--regress` should be used.

`input_file` and `output_file` can be a simple filename or a full path.

The program was created using Julia version 1.6.2; it will likely work in any other version that has not had any breaking changes to functions used in the code.
