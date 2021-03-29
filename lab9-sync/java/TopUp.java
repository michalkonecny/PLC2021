public class TopUp
{
    public static void main(String[] args)
    {
        PhoneAccount acc1 = new PhoneAccount("Account 1");
        new Thread(new MakingCalls(acc1)).start();
        new Thread(new ToppingUp(acc1)).start();

        PhoneAccount acc2 = new PhoneAccount("Account 2");
        new Thread(new MakingCalls(acc2)).start();
    }

    private static class MakingCalls implements Runnable
    {
        private PhoneAccount account;

        public MakingCalls(PhoneAccount acc)
        {
            this.account = acc;
        }

        public void run()
        {
            int cost = 1;
            try
            {
                while(true){
                    account.makeCall(cost);
                    Thread.sleep(1000);
                    cost ++;
                }
            }
            catch (InterruptedException e) {} // can ignore this exception
        }
    }

    private static class ToppingUp implements Runnable
    {

        private PhoneAccount account;

        public ToppingUp(PhoneAccount acc)
        {
            this.account = acc;
        }

        public void run()
        {
            while (true)
            {
                account.waitUntilNearlyEmpty();
                account.topUp(10);
            }
        }
    }


    private static class PhoneAccount
    {
        private String name;
        private int credit = 0;

        public PhoneAccount(String name) { this.name = name; }

        private void log(String msg){ System.out.println(name + ": " + msg); }

        public synchronized void waitUntilNearlyEmpty()
        {
            // wait until not paused:
            while( credit > 5 )
            {
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {}
            }
        }

        public synchronized void makeCall(int cost)
        {
            if(credit >= cost){
                synchronized(this){
                    credit = credit - cost;
                }
                log("Made call costing " + cost);
            }else{
                log("Failed to make call costing " + cost);
            }
        }

        public synchronized void topUp(int amount)
        {
            int newcredit = credit + amount;
            log(String.format("Top-up %d: %d -> %d\n", amount, credit, newcredit));
            credit = newcredit;
        }
    }

}
