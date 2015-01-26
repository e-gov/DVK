package ee.ml.dev;

import java.math.BigDecimal;

public class DvkStuff
{
	public static class Company
	{
		private String code;
		private String name;

		public String getCode() {
			return code;
		}

		public void setCode(String code) {
			this.code = code;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

	}

	public static class Person
	{
		private String firstName;
		private String lastName;
		private String id;

		public String getFirstName() {
			return firstName;
		}

		public void setFirstName(String firstName) {
			this.firstName = firstName;
		}

		public String getLastName() {
			return lastName;
		}

		public void setLastName(String lastName) {
			this.lastName = lastName;
		}

		public String getId() {
			return id;
		}

		public void setId(String id) {
			this.id = id;
		}

	}

	public static class Subdivision
	{
		private String name;
		private BigDecimal code;
		private BigDecimal id;

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public BigDecimal getCode() {
			return code;
		}

		public void setCode(BigDecimal code) {
			this.code = code;
		}

		public BigDecimal getId() {
			return id;
		}

		public void setId(BigDecimal id) {
			this.id = id;
		}

	}

	public static class Occupation
	{
		private String name;
		private BigDecimal code;
		private BigDecimal id;

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public BigDecimal getCode() {
			return code;
		}

		public void setCode(BigDecimal code) {
			this.code = code;
		}

		public BigDecimal getId() {
			return id;
		}

		public void setId(BigDecimal id) {
			this.id = id;
		}
	}
}
