import json

import solcx


def main():
    version = solcx.install_solc("0.8.25")

    # Read Solidity contract file
    with open("./contracts/SimpleStorage.sol", "r") as file:
        simple_storage_file = file.read()

    # Compile Solidity
    compiled_sol = solcx.compile_standard(
        {
            "language": "Solidity",
            "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
            "settings": {
                "outputSelection": {
                    "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
                }
            },
        },
        solc_version=version,
    )

    with open("compiled_code.json", "w") as file:
        json.dump(compiled_sol, file)

    # Deploy contract
    compiled_simple_storage = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]
    bytecode = compiled_simple_storage["evm"]["bytecode"]["object"]
    abi = compiled_simple_storage["abi"]


if __name__ == "__main__":
    main()
