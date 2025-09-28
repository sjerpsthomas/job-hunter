extends Node


const locale = "en"



func txt(input: String) -> String:
	if locale == "en":
		return {
			'loading': 'loading portfolio...',
			'error': 'Error loading portfolio.\nPlease refresh to try again.',
			'play': 'Play!',
			
			'select': 'SELECT',
			'inspect': 'INSPECT',
			'discard': 'DISCARD',
			'left': 'left',
			
			'final_score': "Final score",
			'replay': 'Play again!',
			'back': 'Back to title screen',
			
			'card': 'CARD',
			'cards': 'CARDS',
			'link': 'LINK',
			'links': 'LINKS',
			
			'common_tags_1': 'COMMON',
			'common_tags_2': ' TAGS',
			
			'duplicate_1': 'DUPLICATE',
			'duplicate_2': ' CARDS',
		}[input]
	else:
		return {
			'loading': 'portfolio laden...',
			'error': 'Error bij laden van portfolio.\nVervers de pagina om het opnieuw te proberen.',
			'play': 'Spelen!',
			
			'select': 'SELECTEER',
			'inspect': 'BEKIJK',
			'discard': 'GOOI WEG',
			'left': 'over',
			
			'final_score': 'Eindscore',
			'replay': 'Opnieuw spelen!',
			'back': 'Terug naar hoofdmenu',
			
			'card': 'KAART',
			'cards': 'KAARTEN',
			'link': 'LINK',
			'links': 'LINKS',
			
			'common_tags_1': 'GEMEENSCHAPPELIJKE',
			'common_tags_2': '-TAGS',
			
			'duplicate_1': 'DUBBELE',
			'duplicate_2': ' KAARTEN',
		}[input]
