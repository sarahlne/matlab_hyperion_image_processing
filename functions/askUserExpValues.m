function [l, k, hsize, sigma] = askUserExpValues()
    disp(['Enter the values of l and k for exponentiall operation ']);
    
    prompt = 'l : ';
    l = input(prompt);

    prompt = 'k : ';
    k = input(prompt);

end