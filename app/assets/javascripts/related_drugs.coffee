$ ->
  $("#related_drugs").load("/drug_groups/" + $("#drug_name").text().trim() + "/related")

