%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 1 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % INPUT Signal:
 duration = input('Enter the number of Durations for all signals : ');
 M = input('Enter the number of Signals : ');
 Amp = input('Enter the amplitude for each duration: ');
 X = 0:1:duration; % Adjusted the range of X
 Y = X';
 y_max = max(max(Amp));
 y_min = min(min(Amp));

 for i = 1:M
 % Extract the signals
 eval(['s', num2str(i), ' = Amp(:,i);']);

 end

 % calculate Basefn_1
 Basefn_1 =orth(s1);
 mul11=Basefn_1 .*s1;
 s11=sum(mul11( :,1));

 if M>1
 for i = 2:M

 g = eval(['s', num2str(i)]); 

 for j = 1 : i-1
 Basefn_j = eval(['Basefn_', num2str(j)]);

 % Ensure Basefn_j has size 3*1
 Basefn_j = Basefn_j(:, 1);

 dummy1 = eval(['s', num2str(i)]) .* Basefn_j; 
 eval(['s', num2str(i),num2str(j),'=sum(dummy1( :,1)) ;']);
 dummy2 =(eval(['s', num2str(i), num2str(j)])) .* Basefn_j;
 g = g - dummy2;
 end

 if g == 0
 eval(['Basefn_',num2str(i),' = zeros(duration, 1);']);
 else
 eval(['Basefn_',num2str(i),' = orth(g);']);
 end
 Basefn_i = eval(['Basefn_', num2str(i)]);
 dummy1 = eval(['s', num2str(i)]) .* Basefn_i; 
 eval(['s', num2str(i),num2str(i),'=sum(dummy1( :,1)) ;']);
 sii=(eval(['s', num2str(i), num2str(i)]));
 mulii=Basefn_i .* eval(['s', num2str(i)]);
 sii=sum(mulii( :,1));
 end
 else
 Basefn_2 = zeros(duration, 1);
 end

 if M<3
 Basefn_3 = zeros(duration, 1);
 end

 % Plotting Input
 figure;
 for j = 1:M
 Z = Amp(:, j);
 Z(duration+1, 1) = 0;
 subplot(M, 1, j); % Adjusted to create a Mumn of subplots
 stairs(Y, Z);
 axis([0, duration, y_min-1, y_max+1]);
 title_txt1 = sprintf('s_%d(t)', j);
 title_txt2 = sprintf('s_%d(t)', j);
 title(title_txt1);
 grid minor;
 aX = gca;
 aX.XAxisLocation = 'origin';
 aX.YAxisLocation = 'origin';
 xlabel('time (sec)');
 ylabel(title_txt2);
 grid on;
 end

 %%% to_plot base_fn 
 figure ; 
 for f = 1:M
 Basefn_f = eval(['Basefn_', num2str(f)]);
 if Basefn_f == 0
 else
 Z = Basefn_f;
 Z(duration+1, 1) = 0;
 subplot(M, 2, f); % Adjusted to create a Mumn of subplots
 stairs(Y, Z);
 axis([0, duration, y_min-1, y_max+1]);
 title_txt1 = sprintf('Basefn_%d(t)', f);
 title_txt2 = sprintf('Basefn_%d(t)', f);
 title(title_txt1);
 grid minor;
 aX = gca;
 aX.XAxisLocation = 'origin';
 aX.YAxisLocation = 'origin';
 xlabel('time (sec)');
 ylabel(title_txt2);
 grid on;
 end

 end

 %%% to plot constellation diagram 
 if Basefn_3 == 0
 phi1(1) = s11;
 phi2(1) = 0; 
 if Basefn_2 ==0;
 for i = 2:M
 phi1(i) = eval(['s', num2str(i), '1']);
 phi2(i) = 0;
 end
 else
 for i = 2:M
 phi1(i) = eval(['s', num2str(i), '1']);
 phi2(i) = eval(['s', num2str(i), '2']);
 end
 end
 figure;
 scatter(phi1, phi2, 'filled');
 grid minor;
 axis equal; % Ensure equal scaling on both axes
 xlabel('Basefn_1-axis');
 ylabel('Basefn_2-axis');
 title('Constellation Diagram');
 grid on;

 else
 phi1(1) = s11;
 phi2(1) = 0;
 phi3(1) = 0;
 phi1(2) = s21;
 phi2(2) = s22;
 phi3(2) = 0;
 for i = 3:M
 phi1(i) = eval(['s', num2str(i), '1']);
 phi2(i) = eval(['s', num2str(i), '2']);
 phi3(i) = eval(['s', num2str(i), '3']);
 end
 figure;
 scatter3(phi1,phi2, phi3, 'filled');
 grid minor;
 aX = gca;
 aX.XAxisLocation = 'origin';
 aX.YAxisLocation = 'origin';
 xlabel('Basefn_1-axis');
 ylabel('Basefn_2-axis');
 zlabel('Basefn_3-axis');
 title('constellation diagram');
 grid on;
 axis([min(phi1)-2, max(phi1)+2, min(phi2)-2, max(phi2)+2, min(phi3)-2, max(phi3)]+2);
 end

 %%Energy part
 for i = 1:M
 Energy = 0;
 for j = 1:i
 Energy = Energy + (eval(['s', num2str(i), num2str(j)])^2);
 end
 eval(['Es', num2str(i), ' = Energy;']);
 end

 
 
 %%%%%%%% Part2 %%%%%%%%
 n_bits=100000;
 Rb=1; % bits per second
 n=10; % samples 
 bits=randn(1,n_bits)>=0;
 Fs=n*Rb; %Sampling frequency
 Ts=1/Fs; % Sampling Period
 N = n*n_bits; % total number of samples
 Tb = 1 / Rb ;
 v_1=1;
 Tmax=Tb*length(bits)-Ts;
 t=0:Ts:Tmax;
 Tb=1/Rb; % Bit period

 %Polar Non return to zero
 for i = 0:length(bits)-1
 if(bits(i+1) == 1)
 y(i*n+1:(i+1)*n) = v_1;
 else
 y(i*n+1:(i+1)*n) = -v_1;
 end
 end

 %plot pnrz bits
 figure;
 plot(t,y,'LineWidth' ,2);
 axis([0,Tmax,-2,2]);

 % eb/no is z 
 z_db=-10:2:6;
 z = 10.^(z_db/10); % convert from db
 SNR = 2*z ; 
 SNR_dB=pow2db(SNR);
 BER = zeros(1,length(z_db));
 error_count=zeros(1,length(z_db));
 for j=1:length(z_db)
 ynoise1(j,:) = awgn(y(:),SNR_dB(j),'measured');
 for k=1:n_bits
 if ynoise1(j,k)>0
 ynoise(j,k) = 1;
 else
 ynoise(j,k) = -1;
 end
 if ynoise(j,k)~=y(k)
 error_count(j)=error_count(j)+1;
 end
 end

 BER(j)=error_count(j)/n_bits;
 %theoretical
 BER_theoretical = 0.5*erfc(sqrt(10.^(z_db/10)));

 %constellation
 figure(5);
 subplot(3, 3, j);
 plot(real(ynoise1(1:1000)), imag(ynoise1(1:1000)),'.');
 title(['Noise Power Level = ', num2str(z_db(j))]);
 xlabel('In-Phase Component');
 ylabel('Quadrature Component');
 axis([-10 10 -3 3]);
 grid on;
 end

 %plot ber vs eb/no 
 figure;
 plotHandle=plot(z_db,log10(BER_theoretical),'g-');
 set(plotHandle,'LineWidth',1.5);
 title('SNR per bit (Eb/N0) Vs BER Curve for PNRZ Modulation Scheme');
 xlabel('SNR per bit (Eb/N0) in dB');
 ylabel('Bit Error Rate (BER)');
 grid on;
 hold on;
 plotHandle=plot(z_db,log10(BER),'bx');
 set(plotHandle,'LineWidth',1.5);
 legend('theoretical BER','BER')
