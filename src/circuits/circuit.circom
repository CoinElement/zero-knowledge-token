pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/poseidon.circom";

template Multiplier2() {
   signal input balanceBefore;
   signal input balanceTransfered;
   signal input hashBefore;
   signal input hashAfter;
   signal input hashTransfer;

   signal invBalance;

   //转帐前的余额比转的钱多
   invBalance <-- balanceBefore > balanceTransfered ? 1 : 0;
   invBalance === 1;

   //转账前的余额的Poseidon电路输出 等于 提供的转帐前余额hash
   component poseidonBefore = Poseidon(1);
   poseidonBefore.inputs[0] <== balanceBefore;
   hashBefore === poseidonBefore.out;

   //转账的数量的Poseidon电路输出 等于 提供的转账数量的hash
   component poseidonTransfered = Poseidon(1);
   poseidonTransfered.inputs[0] <== balanceTransfered;
   hashTransfer === poseidonTransfered.out;

   //转账后的余额（通过计算获得）的Poseidon电路输出 等于 提供的转账后余额的hash
   component poseidonAfter = Poseidon(1);
   poseidonAfter.inputs[0] <== balanceBefore - balanceTransfered;
   hashAfter === poseidonAfter.out;
}

component main {public [hashBefore, hashAfter, hashTransfer]} = Multiplier2();
