using LinearAlgebra

function ronda(B, H, R, segundos)
	for i = 1:segundos
		B, H = iteracao(B, H, R)
	end
	return B, H
end

function iteracao(B, H, R)
	for i = 1:20
		ruido = (0.0000001*randn()) * ones(3, 3)
		R = R + ruido
		
		H = R * H
		B = R' * B
	end
	return B, H
end

function ronda_ortogonal(B, H, R, segundos)
	for i = 1:segundos
		B, H = iteracao_ortogonal(B, H, R)
	end
	return B, H
end

function iteracao_ortogonal(B, H, R)
	for i = 1:20
		ruido = (0.0000001*randn()) * ones(3, 3)
		R = R + ruido
		
		SVD_R = svd(R)
		R = SVD_R.U * SVD_R.Vt
		
		H = R * H
		B = R' * B
	end	
	return B, H
end

function simula_simples(B, H, R, tempo)
	B_simples, H_simples = ronda(B, H, R, tempo)

	print("Simulação simples : \n")
	#display(H_simples)
	print("B' = ")
	display(H_simples' * H_simples)
end

function simula_QS(B, H, R, tempo)
	B_ortogonal, H_ortogonal = ronda_ortogonal(B, H, R, tempo)

	print("Simulação com Polar : \n")
	#display(H_ortogonal)
	print("B' = ")
	display(H_ortogonal' * H_ortogonal)
end

B = Matrix{Float64}(1.0I, 3, 3)
H = Matrix{Float64}(1.0I, 3, 3)

angulo = 0.00695
taxa_atualizacoes = 20

theta = angulo/taxa_atualizacoes

R = [cos(theta) -sin(theta) 0
		sin(theta) cos(theta) 0
		0 0 1]

tempos = [1, 60, 60*60, 24*60*60, 30*24*60*60]

println("OBS: Os resultados serão diferentes a cada rodada de testes, devido ao ruido aleatorio nas funções de iteração")

for tempo in tempos
	println("================")
	println("Simulação de ", tempo, "s")
	println("")
	simula_simples(B, H, R, tempo)
	println("")
	simula_QS(B, H, R, tempo)
	println("")
	println("================")
end
