# Zero Knoledge Token

### Start a node
```
npm run hardhat:node
```

### Compile
```
npm run compile
```

### Deploy
```
npm run hardhat:deploy
```

# SnarkJS
## 使用
### 创建 Power Of Tau 文件
### 编译
```
circom circuit.circom --r1cs --wasm --sym
```
在这一步，使用 circom 文件编译了 r1cs，wasm，sym 文件（还可以编译成其它类型的）

### 计算 witness
```
circuit_js$ node generate_witness.js circuit.wasm ../input.json ../witness.wtns
```

这里使用了编译出的 wasm 根据给定的 input.json （包括了所有的公开输入）生成 witness.wtns 文件。

### Setup
这一步，可以使用两个算法：Plonk 和 growth16 生成 zkey文件，zkey 包含了两个部分，proving 和 verification 两个的 密钥

Plonk:
```
snarkjs plonk setup circuit.r1cs pot12_final.ptau circuit_final.zkey
```

### 验证
#### 创建 Proving
```
snarkjs plonk prove circuit_final.zkey witness.wtns proof.json public.json
```

这里使用 zkey 和 计算出的 witness 生成了 proof.json 和 public.json 两个文件。

proof.json 包含了实际的 proof

public.json 包含了所有的公开的输入和输出

#### 验证 Proving
```
snarkjs plonk verify verification_key.json public.json proof.json
```

### 转换为智能合约
```
snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol
```
