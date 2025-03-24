// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity >=0.8.0;

/// ██████╗ ██╗  ██╗ █████╗ ██╗     ██╗     ███████╗███╗   ██╗ ██████╗ ███████╗
/// ██╔════╝██║  ██║██╔══██╗██║     ██║     ██╔════╝████╗  ██║██╔════╝ ██╔════╝
/// ██║     ███████║███████║██║     ██║     █████╗  ██╔██╗ ██║██║  ███╗█████╗
/// ██║     ██╔══██║██╔══██║██║     ██║     ██╔══╝  ██║╚██╗██║██║   ██║██╔══╝
/// ╚██████╗██║  ██║██║  ██║███████╗███████╗███████╗██║ ╚████║╚██████╔╝███████╗
/// ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
///
///  ██████╗ ██████╗
/// ██╔═████╗╚════██╗
/// ██║██╔██║ █████╔╝
/// ████╔╝██║██╔═══╝
/// ╚██████╔╝███████╗
/// ╚═════╝ ╚══════╝

/// @notice Modern and gas efficient ERC20
contract Challenge02 {
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    string public name;

    string public symbol;

    uint8 public immutable decimals;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function approve(address owner, address spender, uint256 amount) public {
        allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        //SIG02 -01- No check if balanceOf[msg.sender] >= amount thus underfow possible
        // require( amount <=  balanceOf[msg.sender],"..")

        balanceOf[msg.sender] -= amount;

        //SIG02 -02- if to  have balance-> If balanceOf(to) + amount > type(uint256).max, to receive less than expected because of overflow
        // so loss of Balance
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        //SIG02 -03- No check if balanceOf[msg.sender] >= amount thus underfow possible
        // require( amount <=  balanceOf[msg.sender],"..")

        uint256 allowed = allowance[from][msg.sender];

        //SIG02 -04- why this if?

        if (allowed != type(uint256).max)
            allowance[from][msg.sender] = allowed - amount;

        balanceOf[from] -= amount;

        //SIG02 -02- if to have balance -> If balanceOf(to) + amount > type(uint256).max, to receive less than expected because of overflow
        // so loss of Balance
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    function _mint(address to, uint256 amount) internal virtual {
        totalSupply += amount;

        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        balanceOf[from] -= amount;

        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}
