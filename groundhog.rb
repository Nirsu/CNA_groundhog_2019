#!/usr/bin/env ruby

class String
    def is_integer?
        self.to_i.to_s == self
    end
    def is_float?
        self.to_f.to_s == self
    end
end

all_temp = Array.new
periode = ARGV
$time_switched = 0
$last_relative = 0
$bool_switch = false

def get_average(periode, all_temp)
    if (all_temp.length <= periode[0].to_i)
        print("g=nan\t")
        return;
    end
    tmp = Array.new
    i = all_temp.length - periode[0].to_i
    while (i != all_temp.length)
        test = all_temp[i].to_f - all_temp[i-1].to_f
        test > 0 ? tmp.push(test) : tmp.push(0)
        i += 1
    end
    g = tmp.inject{ |sum, el| sum + el }.to_f / periode[0].to_i
    print("g=%0.2f\t" % g)
end

def get_relative(periode, all_temp)
    if (all_temp.length <= periode[0].to_i)
        print("r=nan%\t")
        return;
    end
    pos = all_temp.length - periode[0].to_i - 1
    temp1 = all_temp.at(pos).to_f
    temp2 = all_temp.last.to_f
    if (temp1 == 0)
        temp1 = 1
    end
    rela = (temp2 - temp1)/temp1 * 100
    if ($last_relative < 0 && rela.round > 0)
        $time_switched += 1
        $bool_switch = true
    elsif ($last_relative > 0 && rela.round < 0)
        $time_switched += 1
        $bool_switch = true
    end
    $last_relative = rela.round
    print("r=" + rela.round.to_s + "%\t")
end

def get_deviation(periode, all_temp)
    if (all_temp.length < periode[0].to_i)
         puts("s=nan")
         return;
    end
    pos = all_temp.length - periode[0].to_i
    tmp = pos
    mu = 0
    while (tmp != all_temp.length)
        mu += all_temp.at(tmp).to_f
        tmp += 1
    end
    mu = mu/periode[0].to_i
    tmp = pos
    sum = 0
    while (tmp != all_temp.length)
        dist = (all_temp.at(tmp).to_f - mu)
        dist = dist * dist
        sum += dist
        tmp += 1
    end
    dev = Math.sqrt(sum/periode[0].to_i)
    if ($bool_switch == true)
        print ("s=%0.2f\t" % dev)
    else
        puts ("s=%0.2f" % dev)
    end
end

def print_switch_message
    if ($bool_switch == true)
        puts("a switch occurs")
        $bool_switch = false
    end
end

if periode.length != 1 || periode[0] == "-h" || periode[0].is_integer? == false
    puts("SYNOPSIS")
    puts("\t./groundhog period\n")
    puts("DESCRIPTION")
    puts("\tperiod\tthe number of days defining a period")
    exit(84)
end

nbr_input = 0

while (1)
    input = STDIN.gets.chomp
    if (input == "STOP")
        if (nbr_input >= periode[0].to_i)
            puts("Global tendency switched " + $time_switched.to_s + " times")
            puts("5 weirdest values are [")
            exit(0)
        else
            puts ("not enough values")
            exit (84)
        end
    end
    if (input.is_integer? == false && input.is_float? == false)
        puts("Invalid temp")
        exit (84)
    end
    all_temp.push(input)
    get_average(periode, all_temp)
    get_relative(periode, all_temp)
    get_deviation(periode, all_temp)
    print_switch_message
    nbr_input += 1
end

exit (84)