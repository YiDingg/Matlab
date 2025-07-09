function R_coll = MyCaculation_BJT_Rcoll(r_O, beta, r_pi, R_B, R_E)
    R_coll = r_O .* (  1 + ( beta./(r_pi+R_B) + 1./r_O) .* MyParallel(R_E, r_pi + R_B)  );
end