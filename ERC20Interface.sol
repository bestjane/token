contract ERC20Interface {
  string public constant name = "Token Name";
  string public constant symbol = "SYM";
  uint8 public constant decimals = 18;

  function totalSupply() public constant returns(uint);
  function balabceOf(address tokenOwner) public constant returns (uint balance);

  function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
  function approve(address spender, uint token) public returns (bool success);

  function transfer(address to, uint tikens) public returns (bool success);
  functin transferFrom(address from, address to, uint tokens) public returns (bool success);

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
