def get_n_highest_clases(result, n=3):
    #sort by values and return the highest n:
    sorted_dict = dict(sorted(result.items(), key=lambda item: item[1], reverse=True))
    return list(sorted_dict.keys())[:n]