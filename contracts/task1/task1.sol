// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// ✅ 创建一个名为Voting的合约，包含以下功能：
// 一个mapping来存储候选人的得票数
// 一个vote函数，允许用户投票给某个候选人
// 一个getVotes函数，返回某个候选人的得票数
// 一个resetVotes函数，重置所有候选人的得票数
contract Voting {
    mapping(string => uint256) private votes;

    string[] private candidates;

    mapping(string => bool) private exists;

    function vote(string calldata candidate) external {
        if (!exists[candidate]) {
            exists[candidate] = true;
            candidates.push(candidate);
        }

        votes[candidate] += 1;
    }

    function getVotes(string calldata candidate) external view returns (uint256) {
        return votes[candidate];
    }

    function resetVotes() external {
        for (uint256 i = 0; i < candidates.length; i++) {
            votes[candidates[i]] = 0;
        }
    }
}
 
// ✅ 反转字符串 (Reverse String)
// 题目描述：反转一个字符串。输入 "abcde"，输出 "edcba"
contract ReverseString {
    function reverse(string calldata input) external pure returns (string memory){
        bytes calldata strBytes = bytes(input);
        uint256 len = strBytes.length;

        bytes memory reversed = new bytes(len);

        for (uint256 i = 0; i < len; i++) {
            reversed[i] = strBytes[len - 1 - i];
        }

        return string(reversed);
    }
}

 
// ✅  用 solidity 实现整数转罗马数字
// 题目描述在 https://leetcode.cn/problems/roman-to-integer/description/3.
contract IntToRoman {

    function intToRoman(uint256 num) external pure returns (string memory) {

        uint256[13] memory values = [
            uint256(1000), 900, 500, 400,
            100,  90,  50,  40,
            10,    9,   5,   4,
            1
        ];

        string[13] memory symbols = [
            "M", "CM", "D", "CD",
            "C", "XC", "L", "XL",
            "X", "IX", "V", "IV",
            "I"
        ];

        bytes memory out;

        for (uint256 i = 0; i < values.length; i++) {
            while (num >= values[i]) {
                num -= values[i];
                out = abi.encodePacked(out, symbols[i]);
            }
        }

        return string(out);
    }
}

// ✅  用 solidity 实现罗马数字转数整数
// 题目描述在 https://leetcode.cn/problems/integer-to-roman/description/
contract RomanToInteger {

    function romanToInt(string calldata s) external pure returns (uint256) {
        bytes calldata b = bytes(s);
        uint256 len = b.length;
        uint256 result = 0;

        for (uint256 i = 0; i < len; i++) {
            uint256 curr = valueOf(b[i]);

            if (i + 1 < len) {
                uint256 next = valueOf(b[i + 1]);
                if (curr < next) {
                    result -= curr;
                    continue;
                }
            }

            result += curr;
        }

        return result;
    }

    function valueOf(bytes1 c) internal pure returns (uint256) {
        if (c == "I") return 1;
        if (c == "V") return 5;
        if (c == "X") return 10;
        if (c == "L") return 50;
        if (c == "C") return 100;
        if (c == "D") return 500;
        if (c == "M") return 1000;
    }
}

// ✅  合并两个有序数组 (Merge Sorted Array)
// 题目描述：将两个有序数组合并为一个有序数组。
contract MergeSortedArray {
    function merge(
        uint256[] calldata a,
        uint256[] calldata b
    ) external pure returns (uint256[] memory) {
        uint256 i = 0;
        uint256 j = 0;
        uint256 k = 0;

        uint256[] memory result = new uint256[](a.length + b.length);

        while (i < a.length && j < b.length) {
            if (a[i] <= b[j]) {
                result[k++] = a[i++];
            } else {
                result[k++] = b[j++];
            }
        }

        while (i < a.length) {
            result[k++] = a[i++];
        }

        while (j < b.length) {
            result[k++] = b[j++];
        }

        return result;
    }
}

// ✅  二分查找 (Binary Search)
// 题目描述：在一个有序数组中查找目标值。
contract BinarySearch {
    function binarySearch(uint256[] calldata arr, uint256 target) external pure returns (int256) {
        if (arr.length == 0) return -1;

        uint256 left = 0;
        uint256 right = arr.length - 1;

        while (left <= right) {
            uint256 mid = left + (right - left) / 2;

            if (arr[mid] == target) {
                return int256(mid);
            } else if (arr[mid] < target) {
                left = mid + 1;
            } else {
                if (mid == 0) break;
                right = mid - 1;
            }
        }

        return -1;
    }
}