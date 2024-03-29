// an max or min node:
class ArithExpBinary extends ArithExp
{
    public BinaryOperator op; // times, plus or power?
    public ArithExp subExpLeft; // operand1
    public ArithExp subExpRight; // operand2

    // An enumerated type for indicating in each ArithExpOp
    // node which operator the node represents.
    protected static enum BinaryOperator
    {
        PLUS, TIMES, POWER;

        // formatting for infix notation:
        public String toSymbol()
        {
            switch(this)
            {
                case PLUS: return "+";
                case TIMES: return "*";
                case POWER: return "^";
                default: throw new Error("internal error in BinaryOperator.toSymbol()");
            }
        }
    }

    // the constructor:
    public ArithExpBinary(BinaryOperator op, ArithExp subExpLeft, ArithExp subExpRight)
    {
        this.op = op;
        this.subExpLeft = subExpLeft;
        this.subExpRight = subExpRight;
    }

    public int countNodes()
    {
        int result = 1;
        result += subExpLeft.countNodes();
        result += subExpRight.countNodes();
        return result;
    }

    @Override
    public void countNodesInOut(IntHolder resultInOut) {
        IntHolder result = new IntHolder(); // allocate space for parameter on stack
        result.value = resultInOut.value; // copy-in
        subExpLeft.countNodesInOut(result);
        subExpRight.countNodesInOut(result);
        resultInOut.value = result.value; // copy-out        
    }

    @Override
    public void countNodesRef(IntHolder result) {
        /* Simulation of reference passing.
         * It is imperfect since in reference passing, 
         * nothing would be allocated on the stack. */
        subExpLeft.countNodesRef(result);
        subExpRight.countNodesRef(result);        
    }

    public double getValue()
    {
      double l = subExpLeft.getValue();
      double r = subExpRight.getValue();
      switch(this.op)
      {
        case PLUS: return  l + r;
        case TIMES: return  l * r;
        case POWER: return  Math.pow(l,r);
        default: throw new Error("internal error in ArithExpBinary.getValue()");
      }
    }

    public void incrementAllNumbers()
    {
        // increment also both sub-expressions:
        // TASK 6.2.(b) (Q2): (complete the method)


    }

    public String toString()
    {
        return "" + op + "(" + subExpLeft + "," + subExpRight + ")";
    }

}
