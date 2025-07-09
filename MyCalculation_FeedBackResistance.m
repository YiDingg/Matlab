function MyCalculation_FeedBackResistance(alpha, R_p, V_out_range, R_1_actual, R_2_actual)
    %R_p = 10e3;
    V_out1 = V_out_range(1);
    V_out2 = V_out_range(2);
    %alpha = 0.6;
    syms R_1 R_2
    eqs = [
        V_out1 == alpha*(1+R_1/(R_2 + R_p))
        V_out2 == alpha*(1+(R_1 + R_p)/(R_2))
    ];
    [R_1, R_2] = solve(eqs, [R_1 R_2]);
    R_1 = round(R_1, 0)
    R_2 = round(R_2, 0)
    V_out = round([alpha*(1+R_1/(R_2 + R_p)), alpha*(1+(R_1 + R_p)/(R_2))], 2)
    
    % 实际选用的值
    %R_1_actual = 240e3; 
    %R_2_actual = 10e3;
    V_out = [alpha*(1+R_1_actual/(R_2_actual + R_p)), alpha*(1+(R_1_actual + R_p)/(R_2_actual))]
end