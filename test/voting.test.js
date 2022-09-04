const Voting = artifacts.require("../contracts/voting.sol");

contract("Voting system", async accounts => {

        var con;
        var eth;
        const [alice, bob, emma, john] = accounts;

        before(async () => {
                con = await Voting.new();
                eth = 1e18;
        });


        it("Ready", async () => {
                assert.equal(await web3.eth.getBalance(bob), (100 * eth).toString());
        });

        describe("Define variables", async () => {
                
                it("owner", async () => {
                        // assert.equal(await con.owner.call(), alice);
                        assert.equal(await con.owner.call(), alice);
                });

                it("unique ID", async () => {
                        assert.equal(typeof con.season, 'function');
                });

                it("Total projects", async () => {
                        assert.equal(typeof con.totalProjects, 'function');
                });

                it("minimum amount", async () => {
                        assert.equal(typeof con.minimumAmount, 'function');
                });

                it("State enum", async () => {
                        assert.equal(typeof con.State, 'function');
                });

                it("total amount collected", async () => {
                        assert.equal(typeof con.totalAmountCollected, 'function');
                });

                it("season", async () => {
                        assert.equal(typeof con.season, 'function');
                });

                it("season starting", async () => {
                        assert.equal(typeof con.seasonStarting, 'function');
                });
        });

        describe("logical test", async () => {
                
        });
});