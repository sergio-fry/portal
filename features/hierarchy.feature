Feature: Pages hierarchy

	Some pages can refer others by links. If page A has a link to page B, it means that A is a parent of B. These relations can have multiple levels, but can't be cylcic.

	Scenario: Page A links to B, page B links to C. Everynig is fine.
		Given Page A
		And Page B
		And Page C

		When Page A links to B
		And Page B links to C

		Then No errors

	

	Scenario: Page A links to B, page B links to C. When page C tryinig to link A - we get error.
		Given Page A
		And Page B
		And Page C
		And Page A links to B
		And Page B links to C

		When Page C links to A

		Then Error 'page cant link to parent'
