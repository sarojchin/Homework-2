pragma solidity ^0.4.15;

contract Betting {
	/* Standard state variables */
	address owner;
	address public gamblerA;
	address public gamblerB;
	address public oracle;
	uint[] outcomes;	// Feel free to replace with a mapping
	uint chosenOutcome;
	/* array of addresses */
	address[] addresses = new address[](2);
	

	/* Structs are custom data structures with self-defined parameters */
	struct Bet {
		uint outcome;
		uint amount;
		bool initialized;
	}

	/* Keep track of every gambler's bet */
	mapping (address => Bet) bets;
	/* Keep track of every player's winnings (if any) */
	mapping (address => uint) winnings;

	/* Add any events you think are necessary */
	event BetMade(address gambler);
	event BetClosed();

	/* Uh Oh, what are these? */
	modifier OwnerOnly() { require(msg.sender == owner); _;}
	modifier OracleOnly() {require(msg.sender == oracle); _;}
	modifier GamblerOnly() {require(msg.sender != owner 
	                        && msg.sender != oracle); _;}

	/* Constructor function, where owner and outcomes are set */
	function BettingContract(uint[] _outcomes) {
	    
	    owner = msg.sender;
	    outcomes = _outcomes;
	}
	


	/* Checks to see if uint _val is in arr */
	function isIn(uint _val, uint[] arr) returns (bool){
	    bool check;
	    for(uint i = 0; i<arr.length; i++){
	        if (_val == arr[i]) {
	            check = true;
	        }
    	}
    	return check;
	}
	
	/* Owner chooses their trusted Oracle */
	function chooseOracle(address _oracle) OwnerOnly() returns (address) {
	    oracle = _oracle;
	    return oracle;
	}

	/* Gamblers place their bets, preferably after calling checkOutcomes */
	function makeBet(uint _outcome, unit _amount) GamblerOnly() payable returns (bool) {
	    gambler = msg.sender;
	    if(addresses[0] !=gambler && addresses[1] != gambler){
	        gamblerA = gambler;
	    }
	    else if(addresses[0]!=0 && addresses[1] !=gambler){
	        gamblerB = gambler;
	    }
	    require(bets[gambler].initialized ==false);
	    bets[gambler].outcome = outcome;
	    bets[gambler].initialized = true;
	    bets[gambler].amount = _amount;
	    return true;
	    
	}

	/* The oracle chooses which outcome wins */
	function makeDecision(uint _outcome) OracleOnly() {
       require(isIn(_outcome,outcomes));
       require(bets[gamblerA].initialized && bets[gamblerB].initialized);
	   chosenOutcome = _outcome;
	   if(chosenOutcome == bets[gamblerA].outcome){
	       winnings[gamblerA]+= bets[gamblerA].amount;
	       winnings[gamblerB] -= bets[gamblerB].amount;}
	   else if(chosenOutcome == bets[gamblerB].outcome){
	       winnings[gamblerB] += bets[gamblerB].amount;
	       winnings[gamblerA] -= bets[gamblerA].amount;
	       }
	   else if(chosenOutcome !=bets[gamblerA].outcome && chosenOutcome != bets[gamblerB].outcome){
	       winnings[oracle] += bets[gamblerA].amount + bets[gamblerB].amount;
	       winnings[gamblerA] -= bets[gamblerA].amount;
	       winnings[gamblerB] -= bets[gamblerB].amount;
	       
	     }
	   }
	   

	       

	/* Allow anyone to withdraw their winnings safely (if they have enough) */
	function withdraw(uint withdrawAmount) returns (uint remainingBal) {
	    remainingBal = winnings[msg.sender];
	    
	}
	
	/* Allow anyone to check the outcomes they can bet on */
	function checkOutcomes() constant returns (uint[]) {
	    return outcomes;
	    
	}
	
	/* Allow anyone to check if they won any bets */
	function checkWinnings() constant returns(uint) {
	    return winnings[msg.sender];
	}

	/* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
	function contractReset() private {
	}

	/* Fallback function */
	function() payable {
		revert();
	}
}
