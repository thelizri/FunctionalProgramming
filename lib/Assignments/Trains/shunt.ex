defmodule Shunt do

	def find([], []) do [] end
	def find([[]], []) do [] end
	def find(state, state) do [] end
	def find([head|fRest], [head|tRest]) do find(fRest, tRest) end
	def find(fromState, [head|rest]) do 
		{behind, ahead} = Train.split(fromState, head)
		behindL = length(behind)
		aheadL = length(ahead)
		[{:one, aheadL+1}, {:two, behindL}, {:one, -(aheadL+1)}, {:two, -behindL} | find(Train.append(ahead, behind), rest)]
	end

end