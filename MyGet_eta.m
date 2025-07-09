function eta = MyGet_eta(y, y_ex)
        eta = (y_ex-y) ./ y;
        if length(eta) == 1
            disp(['eta = ', num2str(eta*100), ' %'])
        end
end
