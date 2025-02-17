### A Pluto.jl notebook ###
# v0.15.0

using Markdown
using InteractiveUtils

# ╔═╡ 863754ac-d0ea-11eb-0a68-83e30f2d48f6
using CitableText, CitableCorpus, EditorsRepo

# ╔═╡ 6378bfe4-a3e1-42a0-969d-e3fc81b3ab43
md"Work with HMT material by page."

# ╔═╡ 8e91e0aa-c8d6-4a5f-834f-fe7d511453d8
md"> Corpora"

# ╔═╡ a047dcd9-d340-4cd6-af9c-5a2b56816203
md"> Useful lists of `CitableNode`s"

# ╔═╡ 605f0b78-b528-41d4-95c8-127a38b19cdc
md"> Functions"

# ╔═╡ 9e7b78f4-aea0-4ad4-b1c9-cd1f260b4400
# Create a citable corpus of archival text in a repo
# This could also be directly loaded from component publication
# or from full CEX publicatoin.
function archivalcorpus(r::EditingRepository, citesdf)
    urns = citesdf[:, :urn]

    corpora = []
    for u in urns
        # 1. Read the source text (here, XML)
        src = textsourceforurn(r, u)
        if isnothing(src)
            # skip it
        else
            # 2. get the EditionBuilder for the urn
            reader = ohco2forurn(citesdf, u)
            # 3. create citable corpus of the archival version
            push!(corpora, reader(src, u))
        end
    end
    CitableCorpus.composite_array(corpora)
end

# ╔═╡ db1a994f-eb0f-4766-a04a-5bedd7f1446b
md"> Metadata"

# ╔═╡ 6d1d5fe2-94b0-4c28-b00e-7f2eaad97e40
# An MID EditorialRepository.  Useful for constructing CITE architecture
# abstractions from complex data sets in a local file system.
repo = begin
	archiveroot = string(pwd() |> dirname, "/archive")
	repository(archiveroot; editions= "tei-editions", dse="dse-data", config="textconfigs")
end


# ╔═╡ d4045c64-1d08-46db-9263-74edc128dde6
normalizedcorpus = begin 
	normednodes = []
	for t in texturns(repo)
		nds = normalizednodes(repo, t)
		push!(normednodes, nds)        
	end
	normed = filter(nodelist -> ! isnothing(nodelist), normednodes) |> Iterators.flatten |> collect 
	filter(cn -> ! isempty(cn.text), normed) |> CitableTextCorpus
end


# ╔═╡ 2570e582-c478-46bc-853e-ef7c34393fee
iliadnormed = filter(cn -> contains(cn.urn.urn, "tlg0012"),  normalizedcorpus.corpus)

# ╔═╡ 318e8c93-3e72-4fff-952d-3a574446e91c
scholianormed = filter(cn -> contains(cn.urn.urn, "tlg5026"),  normalizedcorpus.corpus)


# ╔═╡ e1591ba9-16d2-45aa-a8a1-50ee7daf0135
commentarynormed = filter(cn -> endswith(passagecomponent(cn.urn),"comment"), normalizedcorpus.corpus)


# ╔═╡ 0042fe1b-fdda-4876-aabb-e91ee11a56e5
reff = filter(cn -> endswith(passagecomponent(cn.urn), "ref"), normalizedcorpus.corpus)



# ╔═╡ 402a4d7c-2060-4b74-9b50-60f5853a9bb2
diplomaticcorpus = begin 
	diplnodes = []
	for t in texturns(repo)
		nds = diplomaticnodes(repo, t)
		push!(diplnodes, nds)        
	end
	diplomatic = filter(nodelist -> ! isnothing(nodelist), diplnodes) |> Iterators.flatten |> collect 
	filter(cn -> ! isempty(cn.text), diplomatic) |> CitableTextCorpus
end

# ╔═╡ 26cc1194-df98-4714-a74f-53b8bbe60181
# Citation configuration for this repository as a DataFrame
citation = citation_df(repo)

# ╔═╡ 93bc8273-b859-4d8b-a85f-e4fe176466c4
archivaltextcorpus = archivalcorpus(repo, citation)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[compat]
CitableCorpus = "~0.2.1"
CitableText = "~0.9.0"
EditorsRepo = "~0.11.5"

[deps]
CitableCorpus = "cf5ac11a-93ef-4a1a-97a3-f6af101603b5"
CitableText = "41e66566-473b-49d4-85b7-da83b66615d8"
EditorsRepo = "3fa2051c-bcb6-4d65-8a68-41ff86d56437"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[AtticGreek]]
deps = ["DocStringExtensions", "Documenter", "Orthography", "PolytonicGreek", "Test", "Unicode"]
git-tree-sha1 = "33d9ae46379002ec79e0925d88e679cc5da94c72"
uuid = "330c8319-f7ed-461a-8c52-cee5da4c0892"
version = "0.6.0"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Statistics", "UUIDs"]
git-tree-sha1 = "9e62e66db34540a0c919d72172cc2f642ac71260"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "0.5.0"

[[CSV]]
deps = ["Dates", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode"]
git-tree-sha1 = "b83aa3f513be680454437a0eee21001607e5d983"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.8.5"

[[CitableBase]]
deps = ["DocStringExtensions", "Documenter", "Test"]
git-tree-sha1 = "e1edbddb151b18f8290b8f19e4310c369b01c049"
uuid = "d6f014bd-995c-41bd-9893-703339864534"
version = "1.2.2"

[[CitableCorpus]]
deps = ["CSV", "CitableText", "DataFrames", "DocStringExtensions", "Documenter", "HTTP", "Test"]
git-tree-sha1 = "ce07aadee5fe89c3e72667a72ea804502b7e2dcf"
uuid = "cf5ac11a-93ef-4a1a-97a3-f6af101603b5"
version = "0.2.1"

[[CitableObject]]
deps = ["CitableBase", "DocStringExtensions", "Documenter", "Test"]
git-tree-sha1 = "dadf5b024b5d104fa03e7596c915858b06605dc3"
uuid = "e2b2f5ea-1cd8-4ce8-9b2b-05dad64c2a57"
version = "0.5.1"

[[CitablePhysicalText]]
deps = ["CitableObject", "CitableText", "DataFrames", "DocStringExtensions", "Documenter", "Test"]
git-tree-sha1 = "aedff017c56a6feab41b802b5ce85eef0128abe5"
uuid = "e38a874e-a7c2-4ff3-8dea-81ae2e5c9b07"
version = "0.2.6"

[[CitableTeiReaders]]
deps = ["CitableCorpus", "CitableText", "DocStringExtensions", "Documenter", "EzXML", "Test"]
git-tree-sha1 = "82e0d3a70d8a689b6f8b0f764591d6bbdc0f6d16"
uuid = "b4325aa9-906c-402e-9c3f-19ab8a88308e"
version = "0.6.4"

[[CitableText]]
deps = ["BenchmarkTools", "CitableBase", "DocStringExtensions", "Documenter", "Test"]
git-tree-sha1 = "3d95c0ceea520fae5248a6842026b99d6ca23356"
uuid = "41e66566-473b-49d4-85b7-da83b66615d8"
version = "0.9.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "e4e2b39db08f967cc1360951f01e8a75ec441cab"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.30.0"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "dfb3b7e89e395be1e25c2ad6d7690dc29cc53b1d"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.6.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "66ee4fe515a9294a8836ef18eea7239c6ac3db5e"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.1.1"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4437b64df1e0adccc3e5d1adbc3ac741095e4677"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.9"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

[[Documenter]]
deps = ["Base64", "Dates", "DocStringExtensions", "IOCapture", "InteractiveUtils", "JSON", "LibGit2", "Logging", "Markdown", "REPL", "Test", "Unicode"]
git-tree-sha1 = "3ebb967819b284dc1e3c0422229b58a40a255649"
uuid = "e30172f5-a6a5-5a46-863b-614d45cd2de4"
version = "0.26.3"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EditionBuilders]]
deps = ["CitableCorpus", "CitableText", "DocStringExtensions", "Documenter", "EzXML", "Test"]
git-tree-sha1 = "5fdf695f515c1146a2604f39e1b7a4f93d28b601"
uuid = "2fb66cca-c1f8-4a32-85dd-1a01a9e8cd8f"
version = "0.4.4"

[[EditorsRepo]]
deps = ["AtticGreek", "CSV", "CitableBase", "CitableCorpus", "CitableObject", "CitablePhysicalText", "CitableTeiReaders", "CitableText", "DataFrames", "DocStringExtensions", "Documenter", "EditionBuilders", "Lycian", "ManuscriptOrthography", "Orthography", "PolytonicGreek", "Test"]
git-tree-sha1 = "120c9e468b0d2c2e9a9b46dc6398c99a7f3807c9"
uuid = "3fa2051c-bcb6-4d65-8a68-41ff86d56437"
version = "0.11.5"

[[EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "0fa3b52a04a4e210aeb1626def9c90df3ae65268"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.1.0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "86ed84701fbfd1142c9786f8e53c595ff5a4def9"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.10"

[[IOCapture]]
deps = ["Logging"]
git-tree-sha1 = "377252859f740c217b936cebcd918a44f9b53b59"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.1.1"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InvertedIndices]]
deps = ["Test"]
git-tree-sha1 = "15732c475062348b0165684ffe28e85ea8396afc"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.0.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Lycian]]
deps = ["DocStringExtensions", "Documenter", "Orthography", "Test"]
git-tree-sha1 = "0afb5162d76290e586e586bdd2fa478a42fad3de"
uuid = "7c215dd3-d1b4-4517-b6c6-0123f1059a20"
version = "0.2.0"

[[ManuscriptOrthography]]
deps = ["DocStringExtensions", "Documenter", "Orthography", "PolytonicGreek", "Test", "Unicode"]
git-tree-sha1 = "db8d37b5da038cc85748b897cb48eb0c16094c18"
uuid = "c7d01213-112e-44c9-bed3-ac95fd3728c7"
version = "0.1.1"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "4ea90bd5d3985ae1f9a908bd4500ae88921c5ce7"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[Orthography]]
deps = ["DocStringExtensions", "Documenter", "Test", "Unicode"]
git-tree-sha1 = "5593d0e9ef2779815073c641f63eca7ea0e2e046"
uuid = "0b4c9448-09b0-4e78-95ea-3eb3328be36d"
version = "0.8.0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "c8abc88faa3f7a3950832ac5d6e690881590d6dc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PolytonicGreek]]
deps = ["DocStringExtensions", "Documenter", "Orthography", "Test", "Unicode"]
git-tree-sha1 = "306667a0336b447004caa299135aedc0eae7ea6c"
uuid = "72b824a7-2b4a-40fa-944c-ac4f345dc63a"
version = "0.12.0"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "cde4ce9d6f33219465b55162811d8de8139c0414"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.2.1"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "0d1245a357cc61c8cd61934c07447aa569ff22e6"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.1.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "ffae887d0f0222a19c406a11c3831776d1383e3d"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.3"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "2ec1962eba973f383239da22e75218565c390a96"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.0"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "aa30f8bb63f9ff3f8303a06c604c8500a69aa791"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.4.3"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─863754ac-d0ea-11eb-0a68-83e30f2d48f6
# ╟─6378bfe4-a3e1-42a0-969d-e3fc81b3ab43
# ╟─8e91e0aa-c8d6-4a5f-834f-fe7d511453d8
# ╟─93bc8273-b859-4d8b-a85f-e4fe176466c4
# ╟─d4045c64-1d08-46db-9263-74edc128dde6
# ╟─402a4d7c-2060-4b74-9b50-60f5853a9bb2
# ╟─a047dcd9-d340-4cd6-af9c-5a2b56816203
# ╟─2570e582-c478-46bc-853e-ef7c34393fee
# ╟─318e8c93-3e72-4fff-952d-3a574446e91c
# ╟─e1591ba9-16d2-45aa-a8a1-50ee7daf0135
# ╟─0042fe1b-fdda-4876-aabb-e91ee11a56e5
# ╟─605f0b78-b528-41d4-95c8-127a38b19cdc
# ╟─9e7b78f4-aea0-4ad4-b1c9-cd1f260b4400
# ╟─db1a994f-eb0f-4766-a04a-5bedd7f1446b
# ╟─6d1d5fe2-94b0-4c28-b00e-7f2eaad97e40
# ╟─26cc1194-df98-4714-a74f-53b8bbe60181
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
