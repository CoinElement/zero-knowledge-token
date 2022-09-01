Implement a “zero-knowledge token” that has the following features. You can feel free to use opensource tools such as circom, libsnark, snarkjs, etc.

Requirements of the contract

1. It stores the users’hashed balances instead of the real balance

存储用户 hash 后的 balance 来取代真实的 balance

2. It has a transfer functionality. To make things simple, the transfer function doesn’t need  to have a  "from" address, the asset is sent from msg.sender. 

When Alice tries to transfer money to Bob, each of them generates their own zero knowledge proof that use the following as public inputs:

A 转钱到 B，每个人使用以下的数据作为输入，生成他们的零知识证明

- The hash of his/her balance before transfer（a）

转移前的 Balance 的 hash

- The hash of his/her balance after transfer（b）

转移后的 Balance 的 hash

- The hash of the transferred value（c）

转移的值的 hash

And use the following as private input

使用以下的作为私有输入
- His/Her balance before the transfer（x）

转移前的 Balance

- The transferred value（y）

转移的值

a = hash(x)

b = hash(x-y)

c = hash(y)

Hint: In the generated verifier, you have to verify at least the following

提示：在生成的验证者，需要验证至少以下两条：

- Alice’s balance is higher than the transfer amount

A 的 余额 比要交易的数量多

- The hashes of the balances after the transfer is indeed the hashes of the balances calculated from private inputs

根据私有输入计算

- The proof is generated off-chain, while the verification must be done in the smart
contract

证明在链下生成，但是验证要在合约里面

- You only need to implement the most basic balance map and the transfer function

你只需要实现最基本的 余额map(?) 和 交易的函数
