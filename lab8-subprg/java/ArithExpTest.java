public abstract class ArithExpTest
{
    public static void main(String[] args)
    {
        ArithExp exp1 =
            new ArithExpBinary
                (
                    ArithExpBinary.BinaryOperator.TIMES,
                    new ArithExpInt(2),
                    new ArithExpBinary
                        (
                            ArithExpBinary.BinaryOperator.PLUS,
                            new ArithExpInt(3),
                            new ArithExpDouble(0.5)
                        )
                );

        int countResult = exp1.countNodes();

        System.out.println("exp1.countNodes() = "+countResult);

        IntHolder countResultH = new IntHolder();
        countResultH.value = 0;
        exp1.countNodesInOut(countResultH);

        System.out.println("exp1.countNodesInOut(countResultH) = "+countResultH.value);

        countResultH.value = 0;
        exp1.countNodesRef(countResultH);

        System.out.println("exp1.countNodesRef(countResultH) = "+countResultH.value);



    }

}


